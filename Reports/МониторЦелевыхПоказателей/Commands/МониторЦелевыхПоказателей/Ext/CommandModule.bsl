﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	#Если МобильныйКлиент Тогда
	ОткрытьФорму("Справочник.ДашбордыМЦП.ФормаСписка", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	#Иначе
	ОткрытьФорму("Отчет.МониторЦелевыхПоказателей.Форма.ФормаМониторЦелевыхПоказателей", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	#КонецЕсли
КонецПроцедуры

#КонецОбласти 