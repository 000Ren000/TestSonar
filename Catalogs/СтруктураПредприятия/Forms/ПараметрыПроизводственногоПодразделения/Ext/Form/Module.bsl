﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоКА = ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	
	Параметры.Свойство("Ссылка", Ссылка);
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаДанныеОбъекта);
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		Объект[Реквизит.Имя] = ДанныеОбъекта[Реквизит.Имя];
	КонецЦикла;
	Для каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		
		Если ТабличнаяЧасть.Имя = "ГрафикиРаботы"
			И Объект.СпособНастройкиГрафикаРаботы = Перечисления.СпособыНастройкиГрафикаРаботыПодразделений.ИндивидуальныйГрафик Тогда
			
			Если ДанныеОбъекта.ГрафикиРаботы.Количество() <> 0 Тогда
				ГрафикРаботы = ДанныеОбъекта.ГрафикиРаботы[0].ГрафикРаботы;
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		Объект[ТабличнаяЧасть.Имя].Загрузить(ДанныеОбъекта[ТабличнаяЧасть.Имя]);
		
	КонецЦикла;
	СкладМатериалов = ДанныеОбъекта.СкладМатериалов;
	
	
	Если Объект.ИспользоватьБригадныеНаряды И Объект.ИспользоватьПерсональныеНаряды Тогда
		ВидыНарядов = "БригадыИРаботники";
	ИначеЕсли Объект.ИспользоватьБригадныеНаряды Тогда
		ВидыНарядов = "Бригады";
	Иначе
		ВидыНарядов = "Работники";
	КонецЕсли;
	
	Если Объект.ИспользуетсяСписаниеЗатратНаВыпуск Тогда
		ИспользованиеСписанияЗатратНаВыпуск = 1;
	Иначе
		ИспользованиеСписанияЗатратНаВыпуск = 2;
	КонецЕсли;
	
	КалендарьПредприятия = Константы.ОсновнойКалендарьПредприятия.Получить();
	Если НЕ КалендарьПредприятия.Пустая() Тогда
		Элементы.СтраницыКалендарьПредприятия.ТекущаяСтраница = Элементы.СтраницаКалендарьЗадан;
	Иначе
		Элементы.СтраницыКалендарьПредприятия.ТекущаяСтраница = Элементы.СтраницаКалендарьНеЗадан;
	КонецЕсли; 
	
	
	
	УправлениеВидимостью();
	
	Если ПравоДоступа("Изменение", Метаданные.Справочники.СтруктураПредприятия) Тогда
		УправлениеДоступностью();
	Иначе
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма,,, Новый Структура("Ссылка", Ссылка));
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.СпособНастройкиГрафикаРаботы = Перечисления.СпособыНастройкиГрафикаРаботыПодразделений.ИндивидуальныйГрафик
			И ГрафикРаботы.Пустая() Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""График работы"" не заполнено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ГрафикРаботы",, Отказ);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗавершитьРедактированиеИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьГрафикПредприятияПриИзменении(Элемент)
	
	Если НЕ ГрафикРаботы.Пустая() Тогда
		ГрафикРаботы = Неопределено;
	КонецЕсли;
	Если Объект.ГрафикиРаботы.Количество() <> 0 Тогда
		Объект.ГрафикиРаботы.Очистить();
	КонецЕсли;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИндивидуальныйГрафикПриИзменении(Элемент)
	
	Если Объект.ГрафикиРаботы.Количество() <> 0 Тогда
		Объект.ГрафикиРаботы.Очистить();
	КонецЕсли;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСменыПриИзменении(Элемент)
	
	Если НЕ ГрафикРаботы.Пустая() Тогда
		ГрафикРаботы = Неопределено;
	КонецЕсли;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалПланированияПриИзменении(Элемент)
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеМаршрутнымиЛистамиПриИзменении(Элемент)
	
	//++ Устарело_Производство21
	УправлениеДоступностью();
	//-- Устарело_Производство21
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПооперационноеУправлениеПриИзменении(Элемент)
	
	Если НЕ Объект.ИспользоватьПооперационноеУправление Тогда
		
		Объект.ИспользоватьМатериалыВОперациях = Ложь;
		Объект.ИспользоватьВыходныеИзделияВОперациях = Ложь;
		Объект.ИспользоватьСменныеЗадания = Ложь;
		Объект.ИспользоватьПооперационноеПланирование = Ложь;
		
	КонецЕсли;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСменныеЗаданияПриИзменении(Элемент)
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПооперационноеПланированиеПриИзменении(Элемент)
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеДоступностиДляГрафикаПроизводстваКоличествоИнтерваловПриИзменении(Элемент)
	
	УстановитьТекстЧасовДнейМесяцевНедель();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеДоступностиДляРасписанияРЦКоличествоИнтерваловПриИзменении(Элемент)
	
	УстановитьТекстЧасовДнейМесяцевНедель();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПроизводствоПоЗаказамПриИзменении(Элемент)
	
	Объект.ПроизводственноеПодразделение = Объект.ПроизводствоБезЗаказов Или Объект.ПроизводствоПоЗаказам;
	
	Если НЕ Объект.ПроизводствоПоЗаказам Тогда
		
		Объект.ИспользоватьПроизводственныеУчастки = Ложь;
		Объект.ИспользоватьПооперационноеУправление = Ложь;
		Объект.ИспользоватьМатериалыВОперациях = Ложь;
		Объект.ИспользоватьВыходныеИзделияВОперациях = Ложь;
		Объект.ИспользоватьСменныеЗадания = Ложь;
		Объект.ИспользоватьПооперационноеПланирование = Ложь;
		
	КонецЕсли;
	
	ОбъектПроизводствоПоЗаказамПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПроизводствоБезЗаказовПриИзменении(Элемент)
	
	Объект.ПроизводственноеПодразделение = Объект.ПроизводствоБезЗаказов Или Объект.ПроизводствоПоЗаказам;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПроизводственноеПодразделениеПриИзменении(Элемент)
	
	Объект.ПроизводствоБезЗаказов = Объект.ПроизводственноеПодразделение;
	
	Если Не ЭтоКА Тогда
		Объект.ПроизводствоПоЗаказам = Объект.ПроизводственноеПодразделение;
	КонецЕсли;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыНарядовПриИзменении(Элемент)
	
	Объект.ИспользоватьБригадныеНаряды = ВидыНарядов = "БригадыИРаботники" Или ВидыНарядов = "Бригады";
	Объект.ИспользоватьПерсональныеНаряды = ВидыНарядов = "БригадыИРаботники" Или ВидыНарядов = "Работники";
	
	Если Не Объект.ИспользоватьБригадныеНаряды Тогда
		Объект.ИспользоватьКТУ = Ложь;
		Объект.ИспользоватьТарифныеСтавки = Ложь;
		Объект.ИспользоватьОтработанноеВремя = Ложь;
	КонецЕсли;
	
	Элементы.ИспользоватьКТУ.Доступность = Объект.ИспользоватьБригадныеНаряды;
	Элементы.ИспользоватьОтработанноеВремя.Доступность = Объект.ИспользоватьБригадныеНаряды;
	Элементы.ИспользоватьТарифныеСтавки.Доступность = Объект.ИспользоватьОтработанноеВремя;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтработанноеВремяПриИзменении(Элемент)
	
	Если Не Объект.ИспользоватьОтработанноеВремя Тогда
		Объект.ИспользоватьТарифныеСтавки = Ложь;
	КонецЕсли;
	
	Элементы.ИспользоватьТарифныеСтавки.Доступность = Объект.ИспользоватьОтработанноеВремя;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСмены

&НаКлиенте
Процедура ГрафикиРаботыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ГрафикиРаботы.ТолькоПросмотр Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Объект.ГрафикиРаботы.НайтиПоИдентификатору(ВыбраннаяСтрока).ГрафикРаботы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗавершитьРедактирование(Команда)
	
	ЗавершитьРедактированиеИЗакрыть(Неопределено, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ПараметрыПроцедуры = ОбщегоНазначенияУТКлиент.ПараметрыРазрешенияРедактированияРеквизитовОбъекта();
	ПараметрыПроцедуры.ИмяФормыРазблокировки = "Справочник.СтруктураПредприятия.Форма.РазблокированиеПараметровПроизводства";
	ПараметрыПроцедуры.ОповещениеОРазблокировке = Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект);
	ПараметрыПроцедуры.Объект = Новый Структура("Ссылка", Ссылка);
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма, ПараметрыПроцедуры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеВидимостью()
	
	
	Возврат; // в УТ пустой
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностью()
	
	ЗапретРедактированияРеквизитов = ИспользуетсяЗапретРедактированияРеквизитов();
	
	
	Если РеквизитДоступенДляРедактирования("ГрафикРаботы", ЗапретРедактированияРеквизитов) Тогда
		Элементы.ГрафикРаботы.Доступность = (Объект.СпособНастройкиГрафикаРаботы
			= Перечисления.СпособыНастройкиГрафикаРаботыПодразделений.ИндивидуальныйГрафик);
		Элементы.ГрафикРаботы.АвтоОтметкаНезаполненного = Элементы.ГрафикРаботы.Доступность;
	КонецЕсли;
	
	Элементы.ГруппаПроизводствоПоЗаказам.Доступность =
		Объект.ПроизводствоПоЗаказам И Производство21
		Или Объект.ПроизводственноеПодразделение И Не Производство21;
	
	Элементы.ГруппаПроизводствоБезЗаказовУП21.Доступность = Не ЭтоКА И Объект.ПроизводствоБезЗаказов;
	Элементы.ГруппаПроизводствоБезЗаказовКА.Доступность   = ЭтоКА И Объект.ПроизводствоБезЗаказов;
	
	Элементы.ГруппаКалендарьПроизводства.Доступность = ЭтоКА И Объект.ПроизводствоБезЗаказов Или Не ЭтоКА;
	Элементы.ГруппаСкладМатериалов.Доступность = ЭтоКА И Объект.ПроизводствоБезЗаказов Или Не ЭтоКА;
	
	Элементы.ГруппаТрудозатраты.Доступность = Объект.ПроизводственноеПодразделение;
	
	Элементы.ИспользоватьКТУ.Доступность = Объект.ИспользоватьБригадныеНаряды;
	Элементы.ИспользоватьОтработанноеВремя.Доступность = Объект.ИспользоватьБригадныеНаряды;
	Элементы.ИспользоватьТарифныеСтавки.Доступность = Объект.ИспользоватьОтработанноеВремя;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЧасовДнейМесяцевНедель()
	
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактированиеИЗакрыть(Результат, ДополнительныеПараметры) Экспорт

	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	Закрыть(
		ПодготовитьДанныеДляЗаписиИПоместитьВХранилище());
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьДанныеДляЗаписиИПоместитьВХранилище()
	
	Объект.ИспользуетсяСписаниеЗатратНаВыпуск =
		ИспользованиеСписанияЗатратНаВыпуск = 1
			И Объект.ПроизводствоБезЗаказов;
	
	Если Объект.СпособНастройкиГрафикаРаботы =
			Перечисления.СпособыНастройкиГрафикаРаботыПодразделений.ИндивидуальныйГрафик Тогда
		Объект.ГрафикиРаботы.Добавить().ГрафикРаботы = ГрафикРаботы;
	КонецЕсли;
	
	
	ДанныеОбъекта = Новый Структура;
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		ДанныеОбъекта.Вставить(Реквизит.Имя, Объект[Реквизит.Имя]);
	КонецЦикла;
	
	Для каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		ДанныеОбъекта.Вставить(ТабличнаяЧасть.Имя, Объект[ТабличнаяЧасть.Имя].Выгрузить());
	КонецЦикла;
	
	ДанныеОбъекта.Вставить("СкладМатериалов", СкладМатериалов);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеОбъекта, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
		УправлениеДоступностью();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбъектПроизводствоПоЗаказамПриИзмененииНаСервере()
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаСервере
Функция ИспользуетсяЗапретРедактированияРеквизитов()
	
	Результат = Ложь;
	
	РеквизитыФормы = ЭтотОбъект.ПолучитьРеквизиты();
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл
		Если РеквизитФормы.Имя = "ПараметрыЗапретаРедактированияРеквизитов" Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция РеквизитДоступенДляРедактирования(ИмяРеквизита, ЗапретРедактированияРеквизитов)
	
	Если НЕ ЗапретРедактированияРеквизитов Тогда
		Результат = Истина;
	Иначе
		
		СтруктураПоиска = Новый Структура("ИмяРеквизита", ИмяРеквизита);
		НайденныеСтроки = ЭтотОбъект.ПараметрыЗапретаРедактированияРеквизитов.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСтроки.Количество() = 0 Тогда
			Результат = Истина;
		Иначе
			Результат = НайденныеСтроки[0].РедактированиеРазрешено;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти

