﻿#Область ПрограммныйИнтерфейс

#Область СобытияФормИСМП

Процедура МодификацияРеквизитовФормы(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты) Экспорт
	
	ПараметрыИнтеграцииФормыПроверки = ПараметрыИнтеграцииФормыПроверкиИПодбора(Форма);
	
	Если ЗначениеЗаполнено(ПараметрыИнтеграцииФормыПроверки.ИмяРеквизитаФормы) Тогда
		ПараметрыИнтеграции.Вставить(Перечисления.ВидыПродукцииИС.Алкогольная, ПараметрыИнтеграцииФормыПроверки);
		
		Если ПараметрыИнтеграцииФормыПроверки.ИспользоватьСтатусПроверкиПодбораДокумента Тогда
			
			ПроверкаИПодборПродукцииИС.ДобавитьТаблицуСтатусовПроверки(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
			
		КонецЕсли;
		
		Если ПараметрыИнтеграцииФормыПроверки.ИспользоватьКолонкуСтатусаПроверкиПодбора Тогда
			
			Если ПараметрыИнтеграцииФормыПроверки.РазмещатьЭлементыИнтерфейса Тогда
				
				ПутьКРеквизиту = ПараметрыИнтеграцииФормыПроверки.ИмяРеквизитаФормыОбъект+"."+ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиТовары;
				ПроверкаИПодборПродукцииИС.ДополнитьТаблицуТоваров(Форма, ПараметрыИнтеграции, ПутьКРеквизиту, ДобавляемыеРеквизиты);
				
			КонецЕсли;
			
			ПроверкаИПодборПродукцииИС.ДобавитьТаблицуШтрихкодовУпаковок(Форма, ПараметрыИнтеграции, ДобавляемыеРеквизиты);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура МодификацияЭлементовФормы(Форма) Экспорт
	
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС");
	Если ПараметрыИнтеграции = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = Форма.ПараметрыИнтеграцииГосИС.Получить(Перечисления.ВидыПродукцииИС.Алкогольная);
	Если Настройки = Неопределено Тогда
		Возврат;
	ИначеЕсли Не Настройки.РазмещатьЭлементыИнтерфейса Тогда
		Возврат;
	КонецЕсли;
	ПроверкаИПодборПродукцииИС.ДобавитьКоманднуюПанельИПодменюПроверкиИПодбора(Форма, Настройки);
	ПроверкаИПодборПродукцииИС.ДобавитьКнопкуПроверкиИПодбора(Форма, Настройки, Перечисления.ВидыПродукцииИС.Алкогольная);
	ПроверкаИПодборПродукцииИС.ДобавитьКолонкуСтатусаПроверкиПодбора(Форма, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ВстраиваниеФормыПроверкиИПодбора

// Возвращает структуру, заполненную значениями по умолчанию, используемую для интеграции формы проверки и подбора
//   в прикладные документы конфигураци - потребителя библиотеки ГосИС. Если передана форма - сразу заполняет ее
//   специфику в переопределяемом модуле.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения, Неопределено - форма для которой возвращаются параметры интеграции
//
// Возвращаемое значение:
//  Структура - (См. ПроверкаИПодборПродукцииИС.ПараметрыИнтеграцииФормПроверкиИПодбора).
//
Функция ПараметрыИнтеграцииФормыПроверкиИПодбора(Форма = Неопределено) Экспорт
	
	ВидПродукции = Перечисления.ВидыПродукцииИС.Алкогольная;
	ВидПродукцииРодительный = НРег(ПолучитьСклоненияСтроки(ВидПродукции, "Л=ru_RU", "ПД=Родительный")[0]);
	ВидПродукцииВинительный = НРег(ПолучитьСклоненияСтроки(ВидПродукции, "Л=ru_RU", "ПД=Винительный")[0]);
	
	ПараметрыИнтеграции = ПроверкаИПодборПродукцииИС.ПараметрыИнтеграцииФормПроверкиИПодбора();
	
	ПараметрыИнтеграции.ИнформацияДляПользователяОБлокировке = НСтр(
		"ru = 'До окончания работы в форме сканирования и проверки маркируемой продукции внесение изменений в данной форме недоступно.'");
	ПараметрыИнтеграции.ИнформацияДляПользователяОПроверке = НСтр(
		"ru = 'Выполняется проверка маркируемой продукции. При окончании работы в форме проверки табличная часть может быть изменена.'");
	
	ПараметрыИнтеграции.Заголовки[0] = СтрШаблон(НСтр("ru = 'Проверить поступившую %1'"),             ВидПродукцииВинительный);
	ПараметрыИнтеграции.Заголовки[1] = СтрШаблон(НСтр("ru = 'Подобрать и проверить %1'"),             ВидПродукцииВинительный);
	ПараметрыИнтеграции.Заголовки[2] = СтрШаблон(НСтр("ru = 'Продолжить проверку поступившей %1'"),   ВидПродукцииРодительный);
	ПараметрыИнтеграции.Заголовки[3] = СтрШаблон(НСтр("ru = 'Продолжить подбор и проверку %1'"),      ВидПродукцииРодительный);
	ПараметрыИнтеграции.Заголовки[4] = СтрШаблон(НСтр("ru = 'Результаты проверки %1'"),               ВидПродукцииРодительный);
	ПараметрыИнтеграции.Заголовки[5] = СтрШаблон(НСтр("ru = 'Результаты подбора %1'"),                ВидПродукцииРодительный);
	ПараметрыИнтеграции.Заголовки[6] = СтрШаблон(НСтр("ru = 'Промежуточные результаты проверки %1'"), ВидПродукцииРодительный);
	ПараметрыИнтеграции.Заголовки[7] = СтрШаблон(НСтр("ru = 'Промежуточные результаты подбора %1'"),  ВидПродукцииРодительный);
	ПараметрыИнтеграции.Заголовки[8] = СтрШаблон(НСтр("ru = 'Возобновить проверку %1'"),              ВидПродукцииРодительный);
	
	// Меняем окончание в словах: поступившую(ие) и поступившей(их)
	Если ИнтеграцияИСКлиентСервер.ПредставлениеВидаПродукцииВоМножественномЧисле(ВидПродукции) Тогда
		ПараметрыИнтеграции.Заголовки[0] = СтрШаблон(НСтр("ru = 'Проверить поступившие %1'"),           ВидПродукцииВинительный);
		ПараметрыИнтеграции.Заголовки[2] = СтрШаблон(НСтр("ru = 'Продолжить проверку поступивших %1'"), ВидПродукцииРодительный);
	КонецЕсли;
	
	Если Форма <> Неопределено Тогда
		ПроверкаИПодборПродукцииЕГАИСПереопределяемый.ПриОпределенииПараметровИнтеграцииФормыПроверкиИПодбора(
			Форма, ПараметрыИнтеграции);
	КонецЕсли;
	
	Возврат ПараметрыИнтеграции;
	
КонецФункции

// Вызывается при закрытии формы проверки и подбора маркируемой продукции из форм прикладных документов
//   в конфигурации - потребителе библиотеки ГосИС и при инициализации формы.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма прикладного документа, в который встраивается функциональность библиотеки ГосИС
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - настраиваемый вид продукции
//  ВидимостьЭлементов - Булево - флаг видимости соответствующего блока по виду продукции
//
Процедура УправлениеЭлементамиОткрытияФормыПроверкиИПодбора(Форма, ВидимостьЭлементов) Экспорт
	
	ВидПродукции = Перечисления.ВидыПродукцииИС.Алкогольная;
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить(ВидПродукции);

	Объект = Форма[ПараметрыИнтеграции.ИмяРеквизитаФормыОбъект];
	
	СтатусПроверкиИПодбора  = ПроверкаИПодборПродукцииИС.СтатусПроверкиИПодбораДокумента(Объект.Ссылка, ВидПродукции, ПараметрыИнтеграции.Сценарий);
	
	Если ПараметрыИнтеграции.ИспользоватьСтатусПроверкиПодбораДокумента Тогда
		
		ПроверкаИПодборПродукцииИС.УстановитьСтатусПоВидуПродукции(Форма, ВидПродукции, СтатусПроверкиИПодбора, ПараметрыИнтеграции.Сценарий);
		ПроверкаИПодборПродукцииИС.ОбновитьИнтерфейсПоВидуПродукции(Форма, ВидПродукции, СтатусПроверкиИПодбора, ПараметрыИнтеграции);
		ПроверкаИПодборПродукцииИС.УстановитьВидимостьЭлементов(Форма, ВидПродукции, ВидимостьЭлементов, ПараметрыИнтеграции.Сценарий);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеВидимостьюЭлементовПроверкиИПодбора(Форма) Экспорт
	
	ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС");
	Если ПараметрыИнтеграции = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавленыЭлементыПодбора = Ложь;
	
	Настройки = Форма.ПараметрыИнтеграцииГосИС.Получить(Перечисления.ВидыПродукцииИС.Алкогольная);
	Если Настройки = Неопределено Тогда
		Возврат;
	ИначеЕсли Не Настройки.РазмещатьЭлементыИнтерфейса Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Форма[Настройки.ИмяРеквизитаФормыОбъект];
	ТабличнаяЧастьТовары = Объект[Настройки.ИмяТабличнойЧастиТовары];
	
	ВидимостьЭлементов = Настройки.ИспользоватьБезМаркируемойПродукции
		Или ЕстьМаркируемаяПродукцияВКоллекции(ТабличнаяЧастьТовары);
	
	ДобавленыЭлементыПодбора = ДобавленыЭлементыПодбора Или ВидимостьЭлементов;
	
	УправлениеЭлементамиОткрытияФормыПроверкиИПодбора(Форма, ВидимостьЭлементов);
	
	ПроверкаИПодборПродукцииЕГАИСПереопределяемый.ПриПримененииПараметровИнтеграцииФормыПроверкиИПодбора(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСоСтатусамиПроверкиПодбораСтрок

// Заполнить кеш штрихкодов упаковок.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
Процедура ЗаполнитьКешШтрихкодовУпаковок(Форма) Экспорт
	
	ПараметрыИнтеграцииФормыПроверки = Форма.ПараметрыИнтеграцииГосИС.Получить(Перечисления.ВидыПродукцииИС.Алкогольная);
	
	Если ПараметрыИнтеграцииФормыПроверки = Неопределено Тогда
		Возврат;
	ИначеЕсли НЕ ПараметрыИнтеграцииФормыПроверки.ИспользоватьКолонкуСтатусаПроверкиПодбора Тогда
		Возврат;
	КонецЕсли;
	
	Настройки                  = ПроверкаИПодборПродукцииИС.НастройкиИсточникаКешаШтрихкодовУпаковок();
	Настройки.Объект           = ПараметрыИнтеграцииФормыПроверки.ИмяРеквизитаФормыОбъект;
	Настройки.Штрихкоды        = ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиШтрихкодыУпаковок;
	Настройки.ШтрихкодУпаковки = ПараметрыИнтеграцииФормыПроверки.ИмяКолонкиШтрихкодУпаковки;
	Настройки.ЧастичноеВыбытие = ПараметрыИнтеграцииФормыПроверки.ДоступноЧастичноеВыбытие;
	Настройки.Сценарий         = ПараметрыИнтеграцииФормыПроверки.Сценарий;
	
	ПроверкаИПодборПродукцииИС.ЗаполнитьКешШтрихкодовУпаковок(Форма, Настройки);

КонецПроцедуры

Процедура ПрименитьКешШтрихкодовУпаковок(Форма, ОбновлениеТаблицыТоваров = Ложь) Экспорт

	ПараметрыИнтеграцииФормыПроверки = Форма.ПараметрыИнтеграцииГосИС.Получить(Перечисления.ВидыПродукцииИС.Алкогольная);
	
	Если ПараметрыИнтеграцииФормыПроверки = Неопределено Тогда
		Возврат;
	ИначеЕсли НЕ ПараметрыИнтеграцииФормыПроверки.ИспользоватьКолонкуСтатусаПроверкиПодбора Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = ПроверкаИПодборПродукцииИС.НастройкиИсточникаКешаШтрихкодовУпаковок();
	Настройки.Объект           = ПараметрыИнтеграцииФормыПроверки.ИмяРеквизитаФормыОбъект;
	Настройки.Штрихкоды        = ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиШтрихкодыУпаковок;
	Настройки.ШтрихкодУпаковки = ПараметрыИнтеграцииФормыПроверки.ИмяКолонкиШтрихкодУпаковки;
	Настройки.Товары           = ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиТовары;
	Настройки.Серии            = ПараметрыИнтеграцииФормыПроверки.ИмяТабличнойЧастиСерии;
	Настройки.ЧастичноеВыбытие = ПараметрыИнтеграцииФормыПроверки.ДоступноЧастичноеВыбытие;
	Настройки.ИспользоватьОСУ  = ПараметрыИнтеграцииФормыПроверки.ДоступныОбъемноСортовыеКоды;
	Настройки.Сценарий         = ПараметрыИнтеграцииФормыПроверки.Сценарий;
	
	ПроверкаИПодборПродукцииИС.ПрименитьКешШтрихкодовУпаковок(Форма, Настройки, ОбновлениеТаблицыТоваров);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетХешСумм

// Пересчитывает хеш-суммы всех упаковок формы и проверяется необходимость перемаркировки.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма проверки и подбора маркируемой продукции.
//
Процедура ПересчитатьХешСуммыВсехУпаковок(Форма) Экспорт

	Если Не Форма.ПроверятьНеобходимостьПеремаркировки Тогда
		Возврат;
	КонецЕсли;

	Если Форма.ДетализацияСтруктурыХранения = Перечисления.ДетализацияСтруктурыХраненияИС.ГрупповыеУпаковки Тогда
		Форма.КоличествоУпаковокКоторыеНеобходимоПеремаркировать = 0;
		ПроверкаИПодборПродукцииЕГАИСКлиентСервер.ОтобразитьИнформациюОНеобходимостиПеремаркировки(Форма);
		Возврат;
	КонецЕсли;
	
	ТаблицаХешСумм = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
	
	Для Каждого СтрокаДерева Из Форма.ДеревоМаркированнойПродукции.ПолучитьЭлементы() Цикл
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаДерева.ТипУпаковки) Тогда
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(СтрокаДерева, ТаблицаХешСумм, Истина);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииИС.ТаблицаПеремаркировки(ТаблицаХешСумм);
	
	ПроверкаИПодборПродукцииЕГАИСКлиентСервер.ПроверитьНеобходимостьПеремаркировки(Форма, ТаблицаПеремаркировки, Ложь);
	
КонецПроцедуры

#КонецОбласти

Функция ДанныеРезультатовПроверки(Форма) Экспорт
	
	ДанныеРезультатовСканированияАлкогольнойПродукции = Новый Структура;
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ДеревоМаркированнойПродукции",             ДанныеФормыВЗначение(Форма.ДеревоМаркированнойПродукции, Тип("ДеревоЗначений")));
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ТаблицаНеМаркируемойПродукции",            ДанныеФормыВЗначение(Форма.ТаблицаНеМаркируемойПродукции, Тип("ТаблицаЗначений")));
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ПулНеизвестныхАкцизныхМарок",              ДанныеФормыВЗначение(Форма.ПулНеизвестныхАкцизныхМарок, Тип("ТаблицаЗначений")));
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("АлкогольнаяПродукцияКОпределениюСправок2", ДанныеФормыВЗначение(Форма.АлкогольнаяПродукцияКОпределениюСправок2, Тип("ДеревоЗначений")));
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("УпаковкиДокумента",                        Форма.УпаковкиДокумента);
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ДетализацияСтруктурыХранения",             Форма.ДетализацияСтруктурыХранения);
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("РежимПроверки",                            Форма.РежимПроверки);
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ДобавленныеУпаковки",                      Форма.ДобавленныеУпаковки);
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ДоступныеДляПроверкиУпаковки",             Форма.ДоступныеДляПроверкиУпаковки);
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("СледующийСтикерОтложено",                  Форма.СледующийСтикерОтложено);
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("СохраненВыборПоМаркируемойПродукции",      Форма.СохраненВыборПоМаркируемойПродукции);
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ДанныеВыбораПоМаркируемойПродукции",       Форма.ДанныеВыбораПоМаркируемойПродукции);
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ШтрихкодТекущейПроверяемойУпаковки",       ШтрихкодТекущейПроверяемойУпаковки(Форма));
	
	ДанныеРезультатовСканированияАлкогольнойПродукции.Вставить("ДанныеРанееСгенерированныхШтрихкодов",
		?(ЭтоАдресВременногоХранилища(Форма.АдресПредыдущихШтрихкодов),
			ПолучитьИзВременногоХранилища(Форма.АдресПредыдущихШтрихкодов),
			Неопределено)
	);
	
	Возврат ДанныеРезультатовСканированияАлкогольнойПродукции;
	
КонецФункции

Функция ШтрихкодТекущейПроверяемойУпаковки(Форма)

	Если Форма.ИдентификаторТекущейПроверяемойУпаковки = - 1 Тогда
		Возврат "";
	Иначе
		СтрокаСПроверяемойУпаковкой = Форма.ДеревоМаркированнойПродукции.НайтиПоИдентификатору(Форма.ИдентификаторТекущейПроверяемойУпаковки);
		
		Если СтрокаСПроверяемойУпаковкой = Неопределено Тогда
			Возврат "";
		Иначе
			Возврат СтрокаСПроверяемойУпаковкой.Штрихкод;
		КонецЕсли;
		
	КонецЕсли;

КонецФункции

Функция РезультатыПроверкиУспешноСохранены(Форма, ПостфиксСохранения, ТекстОшибки) Экспорт
	
	ПроверяемыйДокумент = Форма.ПроверяемыйДокумент;
	
	Попытка
		
		ДокументОснованиеОбъект = ПроверяемыйДокумент.ПолучитьОбъект();
		ДокументОснованиеОбъект.Заблокировать();
		
	Исключение
		
		ТекстОшибки = ОписаниеОшибки();
		Возврат Ложь;
		
	КонецПопытки;
	
	ДанныеРезультатовПроверки = ДанныеРезультатовПроверки(Форма);
	
	ДокументОснованиеОбъект["ДанныеПроверкиИПодбора" + ПостфиксСохранения] = Новый ХранилищеЗначения(ДанныеРезультатовПроверки);
	
	Если ПроверяемыйДокумент.Метаданные().Реквизиты.Найти("СтатусПроверкиИПодбора"+ПостфиксСохранения) <> Неопределено Тогда
		ДокументОснованиеОбъект["СтатусПроверкиИПодбора" + ПостфиксСохранения] = Перечисления.СтатусыПроверкиИПодбораИС.Выполняется;
	КонецЕсли;
	
	РежимЗаписи = ?(ДокументОснованиеОбъект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись);
	
	ДокументОснованиеОбъект.Записать(РежимЗаписи);
	
	Возврат Истина;
	
КонецФункции

#Область НаличиеМаркируемойПродукции

Функция НаличиеМаркируемойПродукции(Ссылка) Экспорт 
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ЕстьМаркируемая", Ложь);
	СтруктураВозврата.Вставить("ЕстьНеМаркируемая", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрШаблон(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
		|	ВидыАлкогольнойПродукции.Маркируемый КАК Маркируемый
		|ИЗ
		|	Документ.%1.Товары КАК ДокументЕГАИСТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
		|		ПО ДокументЕГАИСТовары.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
		|		ПО КлассификаторАлкогольнойПродукцииЕГАИС.ВидПродукции = ВидыАлкогольнойПродукции.Ссылка
		|ГДЕ
		|	ДокументЕГАИСТовары.Ссылка = &Ссылка
		|	И ДокументЕГАИСТовары.АлкогольнаяПродукция <> ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)
		|;
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
		|	Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	Документ.%1.Товары КАК ДокументЕГАИСТовары
		|ГДЕ
		|	ДокументЕГАИСТовары.Ссылка = &Ссылка
		|	И ДокументЕГАИСТовары.АлкогольнаяПродукция = ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)
		|;
		|",
		Ссылка.Метаданные().Имя)
		+ ИнтеграцияИС.ТекстЗапросаПризнакаМаркируемаяПродукцияПоНоменклатуре();
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Пакет = Запрос.ВыполнитьПакет();
	
	Выборка = Пакет[0].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Маркируемый Тогда
			СтруктураВозврата.ЕстьМаркируемая = Истина;
		Иначе
			СтруктураВозврата.ЕстьНеМаркируемая = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Выборка = Пакет[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Маркируемый Тогда
			СтруктураВозврата.ЕстьМаркируемая = Истина;
		Иначе
			СтруктураВозврата.ЕстьНеМаркируемая = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	
	Возврат СтруктураВозврата; 
	
КонецФункции

Функция ЕстьМаркируемаяПродукцияВКоллекции(ТабличнаяЧастьТовары) Экспорт
	
	ЕстьМаркируемаяПродукция = Ложь;
	
	ПроверкаИПодборПродукцииЕГАИСПереопределяемый.ЕстьМаркируемаяПродукцияВКоллекции(ТабличнаяЧастьТовары, ЕстьМаркируемаяПродукция);
	
	Возврат ЕстьМаркируемаяПродукция;
	
КонецФункции

#КонецОбласти

#КонецОбласти
