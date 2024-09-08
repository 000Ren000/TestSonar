﻿
#Область ПрограммныйИнтерфейс

#Область ФискальныеОперации

// Запускает механизм проверки кодов маркировки средствами ККТ
// 
// Параметры:
//  ПозицииЧека - Массив - Позиции чека
//  ФормаВладелец - ФормаКлиентскогоПриложения - Форма владелец
//  ЗаголовокКнопкиИгнорировать - Строка, Неопределено - Заголовок кнопки игнорировать
//  ОповещениеОЗавершении - ОписаниеОповещения - Оповещение о завершении
//  ФормаПросмотра - ФормаКлиентскогоПриложения, Неопределено - Форма просмотра
Процедура ПроверитьКодМаркировкиСредствамиККТ(ПозицииЧека, ФормаВладелец, ЗаголовокКнопкиИгнорировать = Неопределено, ОповещениеОЗавершении, ФормаПросмотра = Неопределено) Экспорт
	
	//++ Локализация
	ПараметрыСканирования = ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования(ФормаВладелец);
	
	Если ФормаПросмотра <> Неопределено
		И МенеджерОборудованияВызовСервера.ФискальноеУстройствоПоддерживаетПроверкуКодовМаркировки(ФормаПросмотра.ОборудованиеККТ) Тогда
		ПараметрыСканирования.ТребуетсяПроверкаСредствамиККТ = Истина;
		ПараметрыСканирования.ККТФФД12ИСМП                   = ФормаПросмотра.ОборудованиеККТ;
		ПараметрыСканирования.НомерФискальногоНакопителя     = РозничныеПродажиВызовСервера.ЗаводскойНомерФискальногоНакопителя(ФормаПросмотра.ОборудованиеККТ);
	КонецЕсли;
	
	ДанныеДляПроверки = Новый Массив;
	
	Для Каждого ПозицияЧека Из ПозицииЧека Цикл
		
		Если НЕ ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ПозицияЧека, "РезультатРаспределенияВрем")
			ИЛИ ПозицияЧека.РезультатРаспределенияВрем = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭлементДанныхДляПроверки = ШтрихкодированиеИСМПКлиент.НовыйЭлементПроверкиСредствамиККТПоДаннымРаспределения(
			ПозицияЧека.РезультатРаспределенияВрем);
		
		ДанныеДляПроверки.Добавить(ЭлементДанныхДляПроверки);
		
	КонецЦикла;
	
	ПараметрыПроверкиКМСредствамиККТ = ШтрихкодированиеОбщегоНазначенияИСМПКлиент.ПараметрыНачалаПроверкиКодовМаркировкиСредствамиККТ();
	ПараметрыПроверкиКМСредствамиККТ.ОповещениеОЗавершении       = ОповещениеОЗавершении;
	ПараметрыПроверкиКМСредствамиККТ.ДанныеДляПроверки           = ДанныеДляПроверки;
	ПараметрыПроверкиКМСредствамиККТ.ПараметрыСканирования       = ПараметрыСканирования;
	ПараметрыПроверкиКМСредствамиККТ.ФормаОсновногоОбъекта       = ФормаВладелец;
	ПараметрыПроверкиКМСредствамиККТ.ФормаВспомогательная        = ФормаПросмотра;
	ПараметрыПроверкиКМСредствамиККТ.ЗаголовокКнопкиИгнорировать = ЗаголовокКнопкиИгнорировать;
	
	Объект = ФормаВладелец.Объект; // ДокументОбъект - 
	ДокументСсылка = Объект.Ссылка;
	
	ПараметрыПроверкиКМСредствамиККТ.ПроверятьЗапросыГИСМТ = Ложь;
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер")
		ИЛИ ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.РасходныйКассовыйОрдер")
		ИЛИ ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте") Тогда
		
		ПараметрыПроверкиКМСредствамиККТ.ЭтоДокументОплаты = Истина;
	
	КонецЕсли;
	
	ШтрихкодированиеИСМПКлиентСерверПереопределяемый.ПриУстановкеДополнительныхПараметровПроверкиКодовМаркировкиСредствамиККТ(ПараметрыПроверкиКМСредствамиККТ, ПараметрыСканирования);
	
	ШтрихкодированиеОбщегоНазначенияИСМПКлиент.НачатьПроверкуКодовМаркировкиСредствамиККТ(ПараметрыПроверкиКМСредствамиККТ);
	//-- Локализация
	
КонецПроцедуры

// Определяет, требуется ли проверка кодов маркировки средствами ККТ.
// 
// Параметры:
//  ПараметрыОперацииФискализацииЧека - Структура - Параметры операции фискализации чека
// 
// Возвращаемое значение:
//  Булево - Истина - требуется проверка кодов маркировки средствами ККТ
Функция ТребуетсяПроверкаКодовМаркировкиСредствамиККТ(ПараметрыОперацииФискализацииЧека) Экспорт
	
	ТребуетсяПроверкаКодовМаркировкиСредствамиККТ = Ложь;
	
	//++ Локализация
	ПозицииЧека = ПараметрыОперацииФискализацииЧека.ПозицииЧека;
	
	Для Каждого ПозицияЧека Из ПозицииЧека Цикл
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ПозицияЧека, "РезультатРаспределенияВрем")
			И ПозицияЧека.РезультатРаспределенияВрем <> Неопределено Тогда
			
			ТребуетсяПроверкаКодовМаркировкиСредствамиККТ = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	//-- Локализация
	
	Возврат ТребуетсяПроверкаКодовМаркировкиСредствамиККТ;
	
КонецФункции

#КонецОбласти

#Область ОплатаСБП

// Определяет, что это операция возврата через систему быстрых платежей. Используется для оптовых документов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - 
//
// Возвращаемое значение:
//  Булево - 
//
Функция ЭтоВозвратЧерезСБП(Форма) Экспорт	
	Результат = Ложь;
	
	//++ Локализация
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте") Тогда
		Если Форма.Объект.Проведен = Истина
			И Форма.Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту")
			И ЗначениеЗаполнено(Форма.Объект.ДоговорЭквайринга)
			И Форма.СпособПроведенияПлатежа = ПредопределенноеЗначение("Перечисление.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей") Тогда
			
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	//-- Локализация
	
	Возврат Результат;
КонецФункции

//++ Локализация

// Выполняет подготовку данных для возврата через систему быстрых платежей. Используется для оптовых документов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма документа оплаты
//  СтруктураСостояниеКассовойСмены - см. РозничныеПродажи.ПолучитьСостояниеКассовойСмены - 
//
// Возвращаемое значение:
//  Структура:
//   *ТекстОшибки - Строка - 
//   *ВозвратОплатыВыполнен - Булево -
//   *ДанныеДляВозвратаОплаты - Структура
//
Функция ПодготовитьДанныеДляВозвратаЧерезСБП(Форма, СтруктураСостояниеКассовойСмены) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("ВозвратОплатыВыполнен", Ложь);
	Результат.Вставить("ДанныеДляВозвратаОплаты", Неопределено);
	
	Объект = Форма.Объект;
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте") Тогда
		
		Если Объект.ОплатаВыполнена Тогда
			Результат.ВозвратОплатыВыполнен = Истина;
		Иначе
			
			ДанныеРасшифровкиДляВозврата = Неопределено;
			Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
				ДанныеРасшифровкиДляВозврата = РозничныеПродажиВызовСервера.ДанныеДляВозвратаПоДокументуОплатыСБП(Объект.ДокументОснование);
				Если ДанныеРасшифровкиДляВозврата = Неопределено Тогда
					ТекстОшибки = НСтр("ru = 'В табличной части ""Расшифровка платежа"" документа основания не найден документ оплаты для проведения возврата через СБП.'");
					Результат.ТекстОшибки = ТекстОшибки;
					Возврат Результат;
				КонецЕсли;
			Иначе
				ДанныеРасшифровкиДляВозврата = РозничныеПродажиКлиентСерверЛокализация.ДанныеДляВозвратаПоДокументуОплатыСБП();
				ДанныеРасшифровкиДляВозврата.ОснованиеПлатежа = Неопределено;
				ДанныеРасшифровкиДляВозврата.Партнер = Объект.Партнер;
			КонецЕсли;
			// Сумма возврата всегда берется из документа. Контроль превышения суммы выполняется на стороне Библиотеки интернет поддержки. 
			// При превышении возникнет ошибка при создании заказа на возврат, чек нельзя будет пробить.
			ДанныеРасшифровкиДляВозврата.Сумма = Объект.СуммаДокумента;
			
			ИнформацияОбОплате = Новый Структура;
			
			ИнформацияОбОплате.Вставить("Документ",               Объект.Ссылка);
			ИнформацияОбОплате.Вставить("ДоступныеВидыОплаты",   РозничныеПродажиКлиентСервер.ДоступныеВидыОплаты(Форма));
			
			ИнформацияОбОплате.Вставить("Наличные",               0);
			ИнформацияОбОплате.Вставить("ПлатежныеКарты",         0);
			ИнформацияОбОплате.Вставить("ПлатежныеКартыОтменено", 0);
			ИнформацияОбОплате.Вставить("ПодарочныеСертификаты",  0);
			ИнформацияОбОплате.Вставить("БонусныеБаллы",          0);
			ИнформацияОбОплате.Вставить("СБП",          		 ДанныеРасшифровкиДляВозврата.Сумма);
			ИнформацияОбОплате.Вставить("СБПОтменено",           0);
			
			ИнформацияОбОплате.Вставить("СуммаДокумента",        ДанныеРасшифровкиДляВозврата.Сумма);
			ИнформацияОбОплате.Вставить("СуммаКОплате",          ДанныеРасшифровкиДляВозврата.Сумма);
			ИнформацияОбОплате.Вставить("СуммаСкидки",           0);
			ИнформацияОбОплате.Вставить("ИтогоОплачено", 0);

			Результат.ДанныеДляВозвратаОплаты = Новый Структура;
			Результат.ДанныеДляВозвратаОплаты.Вставить("ИнформацияОбОплате",     ИнформацияОбОплате);
			
			Результат.ДанныеДляВозвратаОплаты.Вставить("Организация",            Объект.Организация);
			Результат.ДанныеДляВозвратаОплаты.Вставить("Партнер",                ДанныеРасшифровкиДляВозврата.Партнер);
			Результат.ДанныеДляВозвратаОплаты.Вставить("КассаККМ",               СтруктураСостояниеКассовойСмены.КассаККМ);
			Результат.ДанныеДляВозвратаОплаты.Вставить("ДатаВозврата",           Объект.Дата);
			Результат.ДанныеДляВозвратаОплаты.Вставить("Валюта",                 Объект.Валюта);
			Результат.ДанныеДляВозвратаОплаты.Вставить("ДокументОплаты",         ДанныеРасшифровкиДляВозврата.ОснованиеПлатежа);
			Результат.ДанныеДляВозвратаОплаты.Вставить("ДоговорПодключения",     Объект.ДоговорЭквайринга);
			Результат.ДанныеДляВозвратаОплаты.Вставить("СсылочныйНомер",         Объект.ИдентификаторОплатыСБП);
			Результат.ДанныеДляВозвратаОплаты.Вставить("БанкКлиента",            Объект.БанкСБП);
				
		КонецЕсли;
	Иначе
		ТекстОшибки = НСтр("ru = 'Для документа %1 операция возврата через Систему Быстрых Платежей не поддерживается.'");
		Результат.ТекстОшибки = СтрШаблон(ТекстОшибки, Форма.Объект.Ссылка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Выполняет операцию возврата через систему быстрых платежей. Используется для оптовых документов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма обработки предпросмотра чека
//  ПараметрыОткрытияФормыОплаты - Структура
//  ОповещениеОЗавершении - ОписаниеОповещения - 
//
Процедура ВыполнитьВозвратЧерезСБП(Форма, ПараметрыОткрытияФормыОплаты, ОповещениеОЗавершении) Экспорт	
	
	ИнформацияОбОплате = ПараметрыОткрытияФормыОплаты.ИнформацияОбОплате;
	Если ТипЗнч(ИнформацияОбОплате.Документ) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте") Тогда
		
		ПараметрыЗавершения = Новый Структура;
		ПараметрыЗавершения.Вставить("Форма", Форма);
		ПараметрыЗавершения.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
		ПараметрыЗавершения.Вставить("ПараметрыОперации", ПараметрыОткрытияФормыОплаты);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатВозвратаОплатыЧерезСБП", ЭтотОбъект, ПараметрыЗавершения);
		
		ОткрытьФорму(
			"Документ.ЧекККМ.Форма.ФормаОплатыСБП",
			ПараметрыОткрытияФормыОплаты,
			Форма,,,,
			ОписаниеОповещения);
	Иначе
		
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Ложь); // Локализация ????!!!!
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет при необходимости запись документа после выполнения возврата оплаты через СБП.
//
// Параметры:
//  РезультатВыполнения - Неопределено, КодВозвратаДиалога, Структура - 
//  ДополнительныеПараметры - Структура
//
Процедура ОбработатьРезультатВозвратаОплатыЧерезСБП(РезультатВыполнения, ДополнительныеПараметры) Экспорт

	Если РезультатВыполнения = Неопределено
		Или РезультатВыполнения = КодВозвратаДиалога.Отмена
		Или Не РезультатВыполнения.Результат Тогда
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗавершении, Ложь);
		Возврат;
	КонецЕсли;

	Если РезультатВыполнения.СуммаВозврата > 0 Тогда
	
		ИнформацияОбОплате = ДополнительныеПараметры.ПараметрыОперации.ИнформацияОбОплате;
		Если ТипЗнч(ИнформацияОбОплате.Документ) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте") Тогда

			ДополнительныеПараметры.Форма.Модифицированность = Истина;

			ВладелецФормы = ДополнительныеПараметры.Форма.ВладелецФормы;
			ВладелецФормы.Объект.ОплатаВыполнена = Истина;
			
			ПодключаемоеОборудованиеУТКлиент.ЗаписатьОбъект(ВладелецФормы, РежимЗаписиДокумента.Проведение, ДополнительныеПараметры.ОповещениеОЗавершении);
			
		КонецЕсли;
	
	КонецЕсли;

КонецПроцедуры

// Начинает операцию вывода QR-кода на дисплей покупателя.
//
// Параметры:
//  ЗначениеQRКода - Строка - Платежная ссылка
//  КартинкаQRКода - Строка - Строка закодированная Base64
//  ОписаниеОповещенияПриЗавершении - ОписаниеОповещения - 
//
Процедура ВывестиQRКодНаДисплейПокупателя(ЗначениеQRКода, КартинкаQRКода, ОписаниеОповещенияПриЗавершении = Неопределено) Экспорт
	
	Если ОписаниеОповещенияПриЗавершении = Неопределено Тогда
		ОписаниеОповещенияПриЗавершении = Новый ОписаниеОповещения("ВывестиQRКодНаДисплейПокупателяЗавершение", ЭтотОбъект);
	КонецЕсли;
	
	ПараметрыОперации = ОборудованиеДисплеиПокупателяКлиент.ПараметрыОперацииДисплейПокупателя();
	ПараметрыОперации.ЗначениеQRКода = ЗначениеQRКода;
	ПараметрыОперации.КартинкаQRКода = КартинкаQRКода;
		
	ОборудованиеДисплеиПокупателяКлиент.НачатьВыводQRКодаНаДисплейПокупателя(
		ОписаниеОповещенияПриЗавершении,
		Новый УникальныйИдентификатор,
		Неопределено,
		ПараметрыОперации);
	
КонецПроцедуры

// Обработчик завершения операции вывода QR-кода на дисплей покупателя. Используется по умолчанию.
// В случае возникновения ошибки, информирует пользователя.
//
// Параметры:
//  РезультатВыполнения - Структура - 
//  Параметры - Структура
//
Процедура ВывестиQRКодНаДисплейПокупателяЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если Не РезультатВыполнения.Результат Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(РезультатВыполнения.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

//++ Локализация
#Область ОплатаЭСФСС

// При изменении адреса сервиса НСПК на форме панели администрирования УТ "Продажи"
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма
Процедура ПанельАдминистрированияУТПродажиАдресСервисаНСПКПриИзменении(Форма) Экспорт
	
	Если ЗначениеЗаполнено(Форма.АдресСервисаНСПК) Тогда
		РозничныеПродажиВызовСервера.ЗаписатьДанныеВБезопасноеХранилище("ЭС_НСПК_МИР", Форма.АдресСервисаНСПК, "АдресСервисаНСПК");
	Иначе
		РозничныеПродажиВызовСервера.УдалитьДанныеИзБезопасногоХранилища("ЭС_НСПК_МИР", "АдресСервисаНСПК");
	КонецЕсли;
	
КонецПроцедуры

// При изменении ключа доступа НСПК на форме панели администрирования УТ "Продажи"
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма
Процедура ПанельАдминистрированияУТПродажиКлючДоступаНСПКПриИзменении(Форма) Экспорт
	
	Если ЗначениеЗаполнено(Форма.КлючДоступаНСПК) Тогда
		РозничныеПродажиВызовСервера.ЗаписатьДанныеВБезопасноеХранилище("ЭС_НСПК_МИР", Форма.КлючДоступаНСПК, "КлючДоступаНСПК");
	Иначе
		РозничныеПродажиВызовСервера.УдалитьДанныеИзБезопасногоХранилища("ЭС_НСПК_МИР", "КлючДоступаНСПК");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область МетодыОбновленияПараметровФискальногоЧека

// Обновляет параметры операции фискализации чека в части разрешительных данных позиций чека.
// 
// Параметры:
// 	ПараметрыОперацииФискализацииЧека - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека - Данные для формирования параметров операции фискализации чека
//  РезультатПроверкиКодовМаркировки - см. ШтрихкодированиеИСМПКлиент.ПараметрыНачалаПроверкиКодовМаркировкиСредствамиККТ
//
Процедура ОбновитьПараметрыФискальногоЧекаЗапросПроверкиКодаПозицийЧека(ПараметрыОперацииФискализацииЧека, РезультатПроверкиКодовМаркировки) Экспорт
	
	Если РезультатПроверкиКодовМаркировки.Свойство("ЭлементыПроверки") 
		И РезультатПроверкиКодовМаркировки.ЭлементыПроверки.Количество() Тогда
		
		ДанныеРазрешительногоРежимаПоКодамМаркировки = Новый Соответствие;
		Для Каждого ЭлементПроверки Из РезультатПроверкиКодовМаркировки.ЭлементыПроверки Цикл 
			Если ЗначениеЗаполнено(ЭлементПроверки.РазрешительныйРежимИдентификаторЗапросаГИСМТ) Тогда 
				ДанныеРазрешительногоРежима = Новый Структура;
				ДанныеРазрешительногоРежима.Вставить("ИдентификаторЗапроса", ЭлементПроверки.РазрешительныйРежимИдентификаторЗапросаГИСМТ);
				ДанныеРазрешительногоРежима.Вставить("ВременнаяМетка", ЭлементПроверки.РазрешительныйРежимДатаЗапросаГИСМТ);
				ДанныеРазрешительногоРежимаПоКодамМаркировки.Вставить(ЭлементПроверки.ПолныйКодМаркировки, ДанныеРазрешительногоРежима);
			КонецЕсли;
		КонецЦикла;
			 
		Для Каждого СтрокаПозицииЧека Из ПараметрыОперацииФискализацииЧека.ПозицииЧека Цикл
			ЗапросПроверкиКода = Неопределено;
			Если ЗначениеЗаполнено(СтрокаПозицииЧека.КонтрольнаяМарка) 
				И СтрокаПозицииЧека.Свойство("ЗапросПроверкиКода", ЗапросПроверкиКода)
				И ТипЗнч(ЗапросПроверкиКода) = Тип("Структура") Тогда
				
	    		ДанныеРазрешительногоРежима = ДанныеРазрешительногоРежимаПоКодамМаркировки[СтрокаПозицииЧека.КонтрольнаяМарка];
				Если Не ДанныеРазрешительногоРежима = Неопределено Тогда
					СтрокаПозицииЧека.ЗапросПроверкиКода.ИдентификаторЗапроса = ДанныеРазрешительногоРежима.ИдентификаторЗапроса;
					СтрокаПозицииЧека.ЗапросПроверкиКода.ВременнаяМетка 	  = ДанныеРазрешительногоРежима.ВременнаяМетка;
				КонецЕсли;
			КонецЕсли;
	    КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РазрешительныйРежимРозничныхПродаж

// Запуск фонового обновления списка CDN-площадок
// 
// Параметры:
//  ИдентификаторУстройстваККТ - СправочникСсылка.ПодключаемоеОборудование - выбранное ККТ
Процедура ЗапуститьПриНеобходимостиОбновлениеСпискаCDNПлощадок(ИдентификаторУстройстваККТ) Экспорт
	
	Если ОбщегоНазначенияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции().Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ПараметрыЗапроса                         = ИнтерфейсИСМПОбщегоНазначенияКлиент.ПараметрыЗапросаДанных();
	ПараметрыЗапроса.УникальныйИдентификатор = Новый УникальныйИдентификатор();
	ПараметрыЗапроса.Параметры               = Новый Структура("НеВыводитьОкноОжидания", Истина);
	ПараметрыЗапроса.ОповещениеОЗавершении   = Новый ОписаниеОповещения("ПослеОбновленияСпискаCDNПлощадок", ЭтотОбъект);
	ПараметрыЗапроса.Организация             = РозничныеПродажиВызовСервера.ОрганизацияФискальногоУстройства(ИдентификаторУстройстваККТ);
	 
	ИнтерфейсИСМПОбщегоНазначенияКлиент.АктуализацияСпискаCDNПлощадок(ПараметрыЗапроса);
	
КонецПроцедуры

// Оповещение о завершении фоновой процедуры обновления списка CDN-площадок
// 
// Параметры:
//  Результат - Структура из КлючИЗначение, Неопределено
//  ДополнительныеПараметры - Структура из КлючИЗначение - дополнительные параметры ответа
Процедура ПослеОбновленияСпискаCDNПлощадок(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.ЕстьОшибки И ЗначениеЗаполнено(Результат.ТекстОшибки)
		Или ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Результат, "Результат")
			И Результат.Результат.Свойство("ОтказОтАвторизации")
			И Результат.Результат.ОтказОтАвторизации Тогда
		
		Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ТекстОшибки);
		КонецЕсли;
		
		ОткрытьФорму("РегистрСведений.СостоянияCDNПлощадокИСМП.Форма.ФормаОшибкиАвторизации",,,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//-- Локализация

#КонецОбласти